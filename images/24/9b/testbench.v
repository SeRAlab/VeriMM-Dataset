`timescale 1ns/1ps

module hazard_detection_mux_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sel;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection_mux dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select A (sel=0)", test_num);
        A = 4'hA;
        B = 4'h5;
        sel = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select B (sel=1)", test_num);
        A = 4'hA;
        B = 4'h5;
        sel = 1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Transition sel 0->1", test_num);
        A = 4'hF;
        B = 4'h0;
        sel = 0;
        #10;
        sel = 1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Transition sel 1->0", test_num);
        A = 4'hC;
        B = 4'h3;
        sel = 1;
        #10;
        sel = 0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Hazard check A=B, transition sel 0->1", test_num);
        A = 4'h7;
        B = 4'h7;
        sel = 0;
        #10;
        sel = 1;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Change active input A (sel=0)", test_num);
        sel = 0;
        A = 4'h1;
        B = 4'hE;
        #10;
        A = 4'h9;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Change active input B (sel=1)", test_num);
        sel = 1;
        A = 4'h8;
        B = 4'h2;
        #10;
        B = 4'hB;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Change inactive input B (sel=0)", test_num);
        sel = 0;
        A = 4'h4;
        B = 4'h0;
        #10;
        B = 4'hF;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: All bits high (4'hF)", test_num);
        A = 4'hF;
        B = 4'hF;
        sel = 1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Alternating pattern transition", test_num);
        A = 4'h5;
        B = 4'hA;
        sel = 1;
        #10;
        sel = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection_mux Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
