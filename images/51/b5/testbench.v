`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg EN;
    wire OVF;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EN(EN),
        .OVF(OVF),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            @(posedge EN);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (15 + 25)", test_num);
            A = 8'd15;
            B = 8'd25;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Case No Overflow (127 + 128)", test_num);
            A = 8'd127;
            B = 8'd128;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Overflow (255 + 1)", test_num);
            A = 8'd255;
            B = 8'd1;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Large Overflow (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
            A = 8'd0;
            B = 8'd0;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max values (255 + 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Functionality (EN low check)", test_num);


            A = 8'd10;
            B = 8'd10;
            @(posedge EN);
            #1;


            @(negedge EN);


            A = 8'd50;
            B = 8'd50;
            #2;


            #1;



            check_outputs(1'b0, 8'd20);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Update after Hold", test_num);


            A = 8'd30;
            B = 8'd30;
            @(posedge EN);
            #1;


            @(negedge EN);
            A = 8'd40;
            B = 8'd40;


            @(posedge EN);
            #1;
            #1;

            check_outputs(1'b0, 8'd80);
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
        input expected_OVF;
        input [7:0] expected_SUM;
        begin
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, SUM=%h",
                         OVF, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, SUM=%h",
                         expected_OVF, expected_SUM);
                $display("  Got:      OVF=%b, SUM=%h",
                         OVF, SUM);
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
        $dumpvars(0,A, B, EN, OVF, SUM);
    end

endmodule
