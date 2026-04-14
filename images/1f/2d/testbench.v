`timescale 1ns/1ps

module wallace_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd0; B = 8'd0;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h00;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd1; B = 8'd1;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'd1;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'hFF;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'd16; B = 8'd16;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'd127; B = 8'd127;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd16129);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h55;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd14450);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'd123; B = 8'd45;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'd200; B = 8'd50;
            $display("Test %0d: %d * %d", test_num, A, B);
            #1;

            check_outputs(16'd10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_multiplier Testbench");
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
        input [15:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
