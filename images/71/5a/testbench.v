`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] A;
    reg [6:0] B;
    reg [6:0] C;
    reg [6:0] D;
    reg [1:0] sel;
    wire [6:0] Y;

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
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input A (sel=00)", test_num);
        A = 7'h5A; B = 7'h23; C = 7'h11; D = 7'h7F; sel = 2'b00;
        #1;

        check_outputs(7'h5A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input B (sel=01)", test_num);
        A = 7'h01; B = 7'h4B; C = 7'h6C; D = 7'h00; sel = 2'b01;
        #1;

        check_outputs(7'h4B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input C (sel=10)", test_num);
        A = 7'h10; B = 7'h20; C = 7'h30; D = 7'h40; sel = 2'b10;
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selecting Input D (sel=11)", test_num);
        A = 7'h7E; B = 7'h3F; C = 7'h1F; D = 7'h0F; sel = 2'b11;
        #1;

        check_outputs(7'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Zeros", test_num);
        A = 7'b0000000; B = 7'b1111111; C = 7'b1111111; D = 7'b1111111; sel = 2'b00;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary - All Ones", test_num);
        A = 7'b0000000; B = 7'b0000000; C = 7'b0000000; D = 7'b1111111; sel = 2'b11;
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggling inputs while sel=10", test_num);
        A = 7'h00; B = 7'h00; D = 7'h00; sel = 2'b10;
        C = 7'h2A;
        #1;

        check_outputs(7'h2A);
        C = 7'h55;
        #1;

        check_outputs(7'h55);
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
        input [6:0] expected_Y;
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
