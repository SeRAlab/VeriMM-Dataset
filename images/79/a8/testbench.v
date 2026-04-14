`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dsp_reset;
    reg [7:0] padd;
    reg pla_ph1;
    reg pla_ph2;
    wire [7:0] out2_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dsp_reset(dsp_reset),
        .padd(padd),
        .pla_ph1(pla_ph1),
        .pla_ph2(pla_ph2),
        .out2_r(out2_r)
    );

    // Clock generation (10ns period)
    initial begin
        dsp_reset = 0;
        forever #5 dsp_reset = ~dsp_reset;
    end

        task reset_dut;

        begin
            dsp_reset = 1;
            pla_ph1 = 0;
            pla_ph2 = 0;
            padd = 8'h00;
            #20;
            dsp_reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            padd = 8'hA5;
            #10;

            pla_ph1 = 1; #10; pla_ph1 = 0;
            #10;

            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            padd = 8'h5A;
            #10;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            #10;
            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            padd = 8'hFF;
            #10;
            pla_ph1 = 1; #10; pla_ph1 = 0;

            #20;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            padd = 8'hCC;
            #10;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            #10;
            padd = 8'hEE;
            #10;
            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            dsp_reset = 1;
            padd = 8'h77;
            #10;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            dsp_reset = 0;
            #10;
            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            padd = 8'h11;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            pla_ph2 = 1; #10; pla_ph2 = 0;

            padd = 8'h22;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            padd = 8'hFF;
            #10;
            pla_ph1 = 1; #10; pla_ph1 = 0;
            #10;
            pla_ph2 = 1; #10; pla_ph2 = 0;
            #10;
            #1;

            check_outputs(8'hFF);
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
        testcase007();
        
        
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
        input [7:0] expected_out2_r;
        begin
            if (expected_out2_r === (expected_out2_r ^ out2_r ^ expected_out2_r)) begin
                $display("PASS");
                $display("  Outputs: out2_r=%h",
                         out2_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out2_r=%h",
                         expected_out2_r);
                $display("  Got:      out2_r=%h",
                         out2_r);
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
        $dumpvars(0,dsp_reset, padd, pla_ph1, pla_ph2, out2_r);
    end

endmodule
