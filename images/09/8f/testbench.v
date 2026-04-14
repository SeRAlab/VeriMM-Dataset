`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg d;
    reg reset;
    reg wl;
    wire bl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .d(d),
        .reset(reset),
        .wl(wl),
        .bl(bl)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            wl = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Store '1' and Read", test_num);
            reset_dut();


            d = 1;
            wl = 1;
            #10;


            wl = 0;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Store '0' and Read", test_num);
            reset_dut();


            d = 0;
            wl = 1;
            #10;


            wl = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data persistence when WL is low", test_num);
            reset_dut();


            d = 1;
            wl = 1;
            #10;


            wl = 0;
            #5;
            d = 0;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset while holding data", test_num);
            reset_dut();


            d = 1;
            wl = 1;
            #10;
            wl = 0;
            #5;


            reset = 1;
            #10;
            reset = 0;
            #5;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overwriting data", test_num);
            reset_dut();


            d = 1;
            wl = 1;
            #10;
            wl = 0;
            #10;


            d = 0;
            wl = 1;
            #10;
            wl = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset priority over Write", test_num);
            reset_dut();


            d = 1;
            wl = 1;
            reset = 1;
            #15;


            reset = 0;
            wl = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_bl;
        begin
            if (expected_bl === (expected_bl ^ bl ^ expected_bl)) begin
                $display("PASS");
                $display("  Outputs: bl=%b",
                         bl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bl=%b",
                         expected_bl);
                $display("  Got:      bl=%b",
                         bl);
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
        $dumpvars(0,d, reset, wl, bl);
    end

endmodule
