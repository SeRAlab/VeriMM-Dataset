`timescale 1ns/1ps

module bidir_shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg load;
    reg [15:0] parallel_in;
    reg rst;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidir_shift_reg dut (
        .clk(clk),
        .dir(dir),
        .load(load),
        .parallel_in(parallel_in),
        .rst(rst),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            dir = 0;
            parallel_in = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load", test_num);
            reset_dut();
            parallel_in = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Left Shift (4 bits)", test_num);
            reset_dut();

            parallel_in = 16'h000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            dir = 1;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Right Shift (4 bits)", test_num);
            reset_dut();

            parallel_in = 16'hF000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            dir = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(16'h0F00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load Priority", test_num);
            reset_dut();

            parallel_in = 16'hAAAA;
            load = 1;
            @(posedge clk);
            #1;

            parallel_in = 16'h5555;
            load = 1;
            dir = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Left Overflow", test_num);
            reset_dut();
            parallel_in = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            dir = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Bidirectional sequence", test_num);
            reset_dut();
            parallel_in = 16'h00FF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            dir = 1;
            repeat(2) @(posedge clk);
            dir = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(16'h01FE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Shift Right Underflow", test_num);
            reset_dut();
            parallel_in = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            dir = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(16'h7FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidir_shift_reg Testbench");
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
        input [15:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, dir, load, parallel_in, rst, parallel_out);
    end

endmodule
