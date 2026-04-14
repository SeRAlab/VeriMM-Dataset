`timescale 1ns/1ps

module prbs_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [9:0] prbs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    prbs_generator dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .prbs(prbs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst <= 1;
            en  <= 0;
            @(posedge clk);
            rst <= 0;
            en  <= 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Enable Low Hold Check", test_num);
            reset_dut();
            en <= 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Step Transition", test_num);
            reset_dut();
            en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multi-Step Sequence Check", test_num);
            reset_dut();
            en <= 1;
            repeat(3) @(posedge clk);
            #1;



            #1;




            check_outputs(10'h3F8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Priority Check", test_num);
            reset_dut();
            en <= 1;
            repeat(5) @(posedge clk);

            @(posedge clk);
            rst <= 1;
            en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Intermittent Enable Check", test_num);
            reset_dut();

            en <= 1;
            @(posedge clk);

            en <= 0;
            repeat(3) @(posedge clk);

            en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("prbs_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [9:0] expected_prbs;
        begin
            if (expected_prbs === (expected_prbs ^ prbs ^ expected_prbs)) begin
                $display("PASS");
                $display("  Outputs: prbs=%h",
                         prbs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prbs=%h",
                         expected_prbs);
                $display("  Got:      prbs=%h",
                         prbs);
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
        $dumpvars(0,clk, en, rst, prbs);
    end

endmodule
