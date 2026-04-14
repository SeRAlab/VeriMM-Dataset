`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S),
        .Y(Y)
    );

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            C = 4'b0000;
            D = 4'b0000;
            S = 2'b00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h5; B = 4'hA; C = 4'h3; D = 4'hF;
            S = 2'b00;
            #10;
            $display("Test Case %0d: Select Input A (S=00)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h5; B = 4'hA; C = 4'h3; D = 4'hF;
            S = 2'b01;
            #10;
            $display("Test Case %0d: Select Input B (S=01)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h5; B = 4'hA; C = 4'h3; D = 4'hF;
            S = 2'b10;
            #10;
            $display("Test Case %0d: Select Input C (S=10)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h5; B = 4'hA; C = 4'h3; D = 4'hF;
            S = 2'b11;
            #10;
            $display("Test Case %0d: Select Input D (S=11)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'b1111; B = 4'b0000; C = 4'b1010; D = 4'b0101;
            S = 2'b10;
            #10;
            $display("Test Case %0d: Select Input C with Alternating Bits", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'h1; B = 4'h2; C = 4'h4; D = 4'h8;
            S = 2'b11;
            #10;
            $display("Test Case %0d: Select Input D with Power of 2", test_num);
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'hE; B = 4'hD; C = 4'hB; D = 4'h7;
            S = 2'b01;
            #10;
            $display("Test Case %0d: Select Input B with Walking Zeros", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [3:0] expected_Y;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, C, D, S, Y);
    end

endmodule
