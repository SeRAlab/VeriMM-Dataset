`timescale 1ns/1ps

module max_return_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] asset1;
    reg [15:0] asset2;
    reg [15:0] asset3;
    reg [15:0] asset4;
    reg [15:0] asset5;
    wire [15:0] max_return_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_return dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .asset4(asset4),
        .asset5(asset5),
        .max_return_out(max_return_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset1 is maximum", test_num);
            asset1 = 16'hFFFF;
            asset2 = 16'h0001;
            asset3 = 16'h1234;
            asset4 = 16'hABCD;
            asset5 = 16'h7FFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset2 is maximum", test_num);
            asset1 = 16'h0005;
            asset2 = 16'h8000;
            asset3 = 16'h7FFF;
            asset4 = 16'h0000;
            asset5 = 16'h4321;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset3 is maximum", test_num);
            asset1 = 16'h1111;
            asset2 = 16'h2222;
            asset3 = 16'hEEEE;
            asset4 = 16'h3333;
            asset5 = 16'h4444;
            #1;

            check_outputs(16'hEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset4 is maximum", test_num);
            asset1 = 16'h0010;
            asset2 = 16'h0020;
            asset3 = 16'h0030;
            asset4 = 16'hFF00;
            asset5 = 16'h0050;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset5 is maximum", test_num);
            asset1 = 16'hAAAA;
            asset2 = 16'hBBBB;
            asset3 = 16'hCCCC;
            asset4 = 16'hDDDD;
            asset5 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs are zero", test_num);
            asset1 = 16'h0000;
            asset2 = 16'h0000;
            asset3 = 16'h0000;
            asset4 = 16'h0000;
            asset5 = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs are the same maximum", test_num);
            asset1 = 16'h5555;
            asset2 = 16'h5555;
            asset3 = 16'h5555;
            asset4 = 16'h5555;
            asset5 = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tie for maximum", test_num);
            asset1 = 16'hAFAF;
            asset2 = 16'h0000;
            asset3 = 16'hAFAF;
            asset4 = 16'h1234;
            asset5 = 16'hAFAF;
            #1;

            check_outputs(16'hAFAF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ascending order", test_num);
            asset1 = 16'h0001;
            asset2 = 16'h0002;
            asset3 = 16'h0003;
            asset4 = 16'h0004;
            asset5 = 16'h0005;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Descending order", test_num);
            asset1 = 16'hFFFF;
            asset2 = 16'hEEEE;
            asset3 = 16'hDDDD;
            asset4 = 16'hCCCC;
            asset5 = 16'hBBBB;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_return Testbench");
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
        input [15:0] expected_max_return_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_return_out === (expected_max_return_out ^ max_return_out ^ expected_max_return_out)) begin
                $display("PASS");
                $display("  Outputs: max_return_out=%h",
                         max_return_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_return_out=%h",
                         expected_max_return_out);
                $display("  Got:      max_return_out=%h",
                         max_return_out);
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
