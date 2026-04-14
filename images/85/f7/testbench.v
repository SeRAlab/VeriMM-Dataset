`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg [1:0] SEL;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select D0 (D0=1, others=0)", test_num);
            D0 = 1; D1 = 0; D2 = 0; D3 = 0; SEL = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select D0 (D0=0, others=1)", test_num);
            D0 = 0; D1 = 1; D2 = 1; D3 = 1; SEL = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select D1 (D1=1, others=0)", test_num);
            D0 = 0; D1 = 1; D2 = 0; D3 = 0; SEL = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select D1 (D1=0, others=1)", test_num);
            D0 = 1; D1 = 0; D2 = 1; D3 = 1; SEL = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select D2 (D2=1, others=0)", test_num);
            D0 = 0; D1 = 0; D2 = 1; D3 = 0; SEL = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select D2 (D2=0, others=1)", test_num);
            D0 = 1; D1 = 1; D2 = 0; D3 = 1; SEL = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select D3 (D3=1, others=0)", test_num);
            D0 = 0; D1 = 0; D2 = 0; D3 = 1; SEL = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select D3 (D3=0, others=1)", test_num);
            D0 = 1; D1 = 1; D2 = 1; D3 = 0; SEL = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Verify all inputs are 1", test_num);
            D0 = 1; D1 = 1; D2 = 1; D3 = 1; SEL = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Verify all inputs are 0", test_num);
            D0 = 0; D1 = 0; D2 = 0; D3 = 0; SEL = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Noise Rejection (Change D1 while SEL is 00)", test_num);
            D0 = 1; D1 = 0; D2 = 0; D3 = 0; SEL = 2'b00;
            #5;
            D1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        testcase011();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
