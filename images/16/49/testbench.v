`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg rst;
    wire [31:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data(data),
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
            data = 64'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input All Zeros", test_num);
            reset_dut();
            data = 64'h0000000000000000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'h0000000000000000));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input All Ones", test_num);
            reset_dut();
            data = 64'hFFFFFFFFFFFFFFFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'hFFFFFFFFFFFFFFFF));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0xAAAA...)", test_num);
            reset_dut();
            data = 64'hAAAAAAAAAAAAAAAA;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'hAAAAAAAAAAAAAAAA));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0x5555...)", test_num);
            reset_dut();
            data = 64'h5555555555555555;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'h5555555555555555));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Set (LSB)", test_num);
            reset_dut();
            data = 64'h0000000000000001;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'h0000000000000001));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Set (MSB)", test_num);
            reset_dut();
            data = 64'h8000000000000000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'h8000000000000000));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 1", test_num);
            reset_dut();
            data = 64'h123456789ABCDEF0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'h123456789ABCDEF0));
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 2", test_num);
            reset_dut();
            data = 64'hDEADBEEFCAFEBABE;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(md5_model(64'hDEADBEEFCAFEBABE));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_hash;
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
        $dumpvars(0,clk, data, rst, hash);
    end

endmodule
