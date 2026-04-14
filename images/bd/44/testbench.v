`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg EN;
    reg [1:0] SEL;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .EN(EN),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            SEL = 2'b00;
            EN = 1'b0;
            #10;
            $display("Testcase %0d: EN=0, SEL=00 (High-Z Check)", test_num);
            #1;

            check_outputs(4'bzzzz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            SEL = 2'b00;
            EN = 1'b1;
            #10;
            $display("Testcase %0d: EN=1, SEL=00 (Select A)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            SEL = 2'b01;
            EN = 1'b1;
            #10;
            $display("Testcase %0d: EN=1, SEL=01 (Select B)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            SEL = 2'b10;
            EN = 1'b1;
            #10;
            $display("Testcase %0d: EN=1, SEL=10 (Select C)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            SEL = 2'b11;
            EN = 1'b1;
            #10;
            $display("Testcase %0d: EN=1, SEL=11 (Select D)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
            SEL = 2'b10;
            EN = 1'b1;
            #5;
            C = 4'hE;
            #5;
            $display("Testcase %0d: Data transparency check (Update C while selected)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'hD; B = 4'h0; C = 4'h0; D = 4'h0;
            SEL = 2'b00;
            EN = 1'b0;
            #5;
            EN = 1'b1;
            #5;
            $display("Testcase %0d: Toggle EN (0->1) with SEL=00", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            SEL = 2'b11;
            EN = 1'b0;
            #10;
            $display("Testcase %0d: EN=0, SEL=11 (High-Z Check)", test_num);
            #1;

            check_outputs(4'bzzzz);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
