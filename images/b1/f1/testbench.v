`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg counter_sel;
    reg [3:0] intossd_2d;
    reg [3:0] intossd_3d;
    reg [3:0] lightctl_2d;
    reg [3:0] lightctl_3d;
    reg stop_2d;
    reg stop_3d;
    wire [3:0] intossd_out;
    wire [3:0] light_ctl_out;
    wire stop_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .counter_sel(counter_sel),
        .intossd_2d(intossd_2d),
        .intossd_3d(intossd_3d),
        .lightctl_2d(lightctl_2d),
        .lightctl_3d(lightctl_3d),
        .stop_2d(stop_2d),
        .stop_3d(stop_3d),
        .intossd_out(intossd_out),
        .light_ctl_out(light_ctl_out),
        .stop_out(stop_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select 2D inputs (counter_sel=0) with simple patterns", test_num);

            counter_sel = 0;
            intossd_2d = 4'hA; intossd_3d = 4'h5;
            lightctl_2d = 4'h3; lightctl_3d = 4'hC;
            stop_2d = 1'b1;    stop_3d = 1'b0;

            #1;


            check_outputs(4'hA, 4'h3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select 3D inputs (counter_sel=1) with simple patterns", test_num);

            counter_sel = 1;
            intossd_2d = 4'hA; intossd_3d = 4'h5;
            lightctl_2d = 4'h3; lightctl_3d = 4'hC;
            stop_2d = 1'b1;    stop_3d = 1'b0;
            #1;

            check_outputs(4'h5, 4'hC, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select 2D inputs with all bits HIGH", test_num);

            counter_sel = 0;
            intossd_2d = 4'hF; intossd_3d = 4'h0;
            lightctl_2d = 4'hF; lightctl_3d = 4'h0;
            stop_2d = 1'b1;    stop_3d = 1'b0;
            #1;

            check_outputs(4'hF, 4'hF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select 3D inputs with all bits HIGH", test_num);

            counter_sel = 1;
            intossd_2d = 4'h0; intossd_3d = 4'hF;
            lightctl_2d = 4'h0; lightctl_3d = 4'hF;
            stop_2d = 1'b0;    stop_3d = 1'b1;
            #1;

            check_outputs(4'hF, 4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Selection 2D with zero values", test_num);

            counter_sel = 0;
            intossd_2d = 4'h0; intossd_3d = 4'hA;
            lightctl_2d = 4'h0; lightctl_3d = 4'hB;
            stop_2d = 1'b0;    stop_3d = 1'b1;
            #1;

            check_outputs(4'h0, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify multiplexer isolation (changing 2D when 3D is selected)", test_num);

            counter_sel = 1;
            intossd_3d = 4'h7; lightctl_3d = 4'h8; stop_3d = 1'b1;

            intossd_2d = 4'hE; lightctl_2d = 4'hE; stop_2d = 1'b0;
            #1;

            check_outputs(4'h7, 4'h8, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify multiplexer isolation (changing 3D when 2D is selected)", test_num);

            counter_sel = 0;
            intossd_2d = 4'h2; lightctl_2d = 4'h4; stop_2d = 1'b0;

            intossd_3d = 4'hF; lightctl_3d = 4'hF; stop_3d = 1'b1;
            #1;

            check_outputs(4'h2, 4'h4, 1'b0);
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
        input [3:0] expected_intossd_out;
        input [3:0] expected_light_ctl_out;
        input expected_stop_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_intossd_out === (expected_intossd_out ^ intossd_out ^ expected_intossd_out) &&
                expected_light_ctl_out === (expected_light_ctl_out ^ light_ctl_out ^ expected_light_ctl_out) &&
                expected_stop_out === (expected_stop_out ^ stop_out ^ expected_stop_out)) begin
                $display("PASS");
                $display("  Outputs: intossd_out=%h, light_ctl_out=%h, stop_out=%b",
                         intossd_out, light_ctl_out, stop_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intossd_out=%h, light_ctl_out=%h, stop_out=%b",
                         expected_intossd_out, expected_light_ctl_out, expected_stop_out);
                $display("  Got:      intossd_out=%h, light_ctl_out=%h, stop_out=%b",
                         intossd_out, light_ctl_out, stop_out);
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

endmodule
