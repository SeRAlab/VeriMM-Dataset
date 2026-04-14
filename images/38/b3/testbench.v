`timescale 1ns/1ps

module SHA256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SHA256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 512-bit All Zeros", test_num);
            reset_dut();
            message = 512'h0;


            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'hda02ce125705643707251f71048220264264639c99443594191c953531a72d17);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 512-bit All Ones", test_num);
            reset_dut();
            message = {64{8'hFF}};

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'hef270f9077271881515efb5873995f573210427320ef457582069b12f68971f1);
        end
        endtask

    task testcase003;

        reg [511:0] msg_pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Incremental Byte Pattern", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                msg_pattern[((63-i)*8) +: 8] = i[7:0];
            end
            message = msg_pattern;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'hf8d8a7a8d83c3165b4c4897e974917614e21689234b33f38f906412e879a832f);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0101...)", test_num);
            reset_dut();
            message = {64{8'h55}};

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'h598006e2329241b21f3ef42379ed2a868f7004f14a60032b49d972412e4f07a0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Padded 'abc' Message", test_num);
            reset_dut();
            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SHA256 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [255:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, message, rst, hash);
    end

endmodule
