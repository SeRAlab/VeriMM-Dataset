`timescale 1ns/1ps

module decoder_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input {C,B,A} = 000 (Y0 should be low)", test_num);
        C = 0; B = 0; A = 0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input {C,B,A} = 001 (Y1 should be low)", test_num);
        C = 0; B = 0; A = 1;
        #1;

        check_outputs(8'hFD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input {C,B,A} = 010 (Y2 should be low)", test_num);
        C = 0; B = 1; A = 0;
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input {C,B,A} = 011 (Y3 should be low)", test_num);
        C = 0; B = 1; A = 1;
        #1;

        check_outputs(8'hF7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input {C,B,A} = 100 (Y4 should be low)", test_num);
        C = 1; B = 0; A = 0;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input {C,B,A} = 101 (Y5 should be low)", test_num);
        C = 1; B = 0; A = 1;
        #1;

        check_outputs(8'hDF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input {C,B,A} = 110 (Y6 should be low)", test_num);
        C = 1; B = 1; A = 0;
        #1;

        check_outputs(8'hBF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input {C,B,A} = 111 (Y7 should be low)", test_num);
        C = 1; B = 1; A = 1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder Testbench");
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
        input [7:0] expected_Y;
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
