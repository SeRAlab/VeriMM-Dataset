`timescale 1ns/1ps

module mux4_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg E;
    reg [1:0] S;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'hA1; B = 8'hB2; C = 8'hC3; D = 8'hD4;
            E = 0;
            S = 2'b00;
            $display("Test %0d: E=0, S=00 - Output should be 0", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF;
            E = 0;
            S = 2'b11;
            $display("Test %0d: E=0, S=11 - Output should be 0 even with inputs active", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'h55; B = 8'hAA; C = 8'h00; D = 8'hFF;
            E = 1;
            S = 2'b00;
            $display("Test %0d: E=1, S=00 - Expecting Y = A (55h)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h55; B = 8'hAA; C = 8'h00; D = 8'hFF;
            E = 1;
            S = 2'b01;
            $display("Test %0d: E=1, S=01 - Expecting Y = B (AAh)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
            E = 1;
            S = 2'b10;
            $display("Test %0d: E=1, S=10 - Expecting Y = C (56h)", test_num);
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
            E = 1;
            S = 2'b11;
            $display("Test %0d: E=1, S=11 - Expecting Y = D (78h)", test_num);
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h00; B = 8'h00; C = 8'hFF; D = 8'h00;
            E = 1;
            S = 2'b10;
            $display("Test %0d: E=1, S=10 - Expecting Y = C (FFh)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hFF; B = 8'h00; C = 8'hFF; D = 8'hFF;
            E = 1;
            S = 2'b01;
            $display("Test %0d: E=1, S=01 - Expecting Y = B (00h)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'hDE; B = 8'hAD; C = 8'hBE; D = 8'hEF;
            S = 2'b11;
            E = 0;
            #5;
            E = 1;
            $display("Test %0d: E=1 after 0, S=11 - Expecting Y = D (EFh)", test_num);
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            E = 1;
            S = 2'b00;
            A = 8'h10;
            #5;
            A = 8'h20;
            $display("Test %0d: E=1, S=00, update A - Expecting Y = updated A (20h)", test_num);
            #1;

            check_outputs(8'h20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4 Testbench");
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
