`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg valid;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .valid(valid),
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
            valid = 0;
            message = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All Zeros Input", test_num);
            reset_dut();

            message = 512'h0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;


            repeat(10) @(posedge clk);



            #1;




            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All Ones Input", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        integer i;
        reg [511:0] pattern;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Incremental Byte Pattern", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end

            message = pattern;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            message = {64{8'hAA}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Idle State Check", test_num);
            reset_dut();


            message = 512'hDEADBEEF_CAFEBABE_01234567_89ABCDEF_DEADBEEF_CAFEBABE_01234567_89ABCDEF_DEADBEEF_CAFEBABE_01234567_89ABCDEF_DEADBEEF_CAFEBABE_01234567_89ABCDEF;
            valid = 0;
            repeat(5) @(posedge clk);



            #1;




            check_outputs(128'h0);
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
        input [127:0] expected_hash;
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
        $dumpvars(0,clk, message, rst, valid, hash);
    end

endmodule
