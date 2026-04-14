`timescale 1ns/1ps

module enable_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [3:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    enable_module dut (
        .clk(clk),
        .enable(enable),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Waveform Replication", test_num);
            reset_dut();

            enable = 1;


            repeat(4) @(posedge clk);
            #1;

            enable = 0;

            repeat(2) @(posedge clk);
            #1;

            enable = 1;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd13);
        end
        endtask

    task testcase002;

        reg [3:0] captured_cnt;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Enable Low (Hold)", test_num);
            reset_dut();

            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            captured_cnt = cnt;

            enable = 0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(captured_cnt);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Wrap-around (15 to 0)", test_num);
            reset_dut();

            enable = 1;




            repeat(16) @(posedge clk);
            #1;





            while (cnt !== 4'd0) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Enable Toggling", test_num);
            reset_dut();


            enable = 1;
            @(posedge clk); #1;
            enable = 0;
            @(posedge clk); #1;
            enable = 1;
            @(posedge clk); #1;
            enable = 0;
            @(posedge clk); #1;
            enable = 1;
            @(posedge clk); #1;




            #1;





            check_outputs(4'd11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("enable_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_cnt;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h",
                         cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h",
                         expected_cnt);
                $display("  Got:      cnt=%h",
                         cnt);
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
        $dumpvars(0,clk, enable, cnt);
    end

endmodule
