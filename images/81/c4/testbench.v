`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bus_00546ebf_;
    reg bus_00ca93e8_;
    reg bus_011957aa_;
    reg bus_015cd3cf_;
    wire bus_0142775d_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_00546ebf_(bus_00546ebf_),
        .bus_00ca93e8_(bus_00ca93e8_),
        .bus_011957aa_(bus_011957aa_),
        .bus_015cd3cf_(bus_015cd3cf_),
        .bus_0142775d_(bus_0142775d_)
    );

    // Clock generation (10ns period)
    initial begin
        bus_00ca93e8_ = 0;
        forever #5 bus_00ca93e8_ = ~bus_00ca93e8_;
    end

        task reset_dut;

        begin
            bus_011957aa_ = 1;
            bus_015cd3cf_ = 0;
            bus_00546ebf_ = 0;
            @(posedge bus_00ca93e8_);
            #1;
            bus_011957aa_ = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;


            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 0;
            @(posedge bus_00ca93e8_);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;


            bus_015cd3cf_ = 0;
            bus_00546ebf_ = 0;
            @(posedge bus_00ca93e8_);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;


            bus_011957aa_ = 1;
            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            bus_015cd3cf_ = 1;
            bus_00546ebf_ = 1;
            @(posedge bus_00ca93e8_);
            #1;


            bus_015cd3cf_ = 0;
            bus_00546ebf_ = 0;
            @(posedge bus_00ca93e8_);
            @(posedge bus_00ca93e8_);
            @(posedge bus_00ca93e8_);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_bus_0142775d_;
        begin
            if (expected_bus_0142775d_ === (expected_bus_0142775d_ ^ bus_0142775d_ ^ expected_bus_0142775d_)) begin
                $display("PASS");
                $display("  Outputs: bus_0142775d_=%b",
                         bus_0142775d_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_0142775d_=%b",
                         expected_bus_0142775d_);
                $display("  Got:      bus_0142775d_=%b",
                         bus_0142775d_);
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
        $dumpvars(0,bus_00546ebf_, bus_00ca93e8_, bus_011957aa_, bus_015cd3cf_, bus_0142775d_);
    end

endmodule
