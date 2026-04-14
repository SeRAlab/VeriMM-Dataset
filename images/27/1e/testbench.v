`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] stock1;
    reg [7:0] stock2;
    reg [7:0] stock3;
    reg [7:0] stock4;
    reg [7:0] stock5;
    wire [7:0] max_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .stock1(stock1),
        .stock2(stock2),
        .stock3(stock3),
        .stock4(stock4),
        .stock5(stock5),
        .max_return(max_return)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Stock 1 is the highest return", test_num);
            stock1 = 8'd250;
            stock2 = 8'd100;
            stock3 = 8'd50;
            stock4 = 8'd10;
            stock5 = 8'd5;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Stock 2 is the highest return", test_num);
            stock1 = 8'd45;
            stock2 = 8'd210;
            stock3 = 8'd150;
            stock4 = 8'd80;
            stock5 = 8'd200;
            #1;

            check_outputs(8'd210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Stock 3 is the highest return", test_num);
            stock1 = 8'd0;
            stock2 = 8'd0;
            stock3 = 8'd128;
            stock4 = 8'd64;
            stock5 = 8'd32;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Stock 4 is the highest return (Max Value)", test_num);
            stock1 = 8'd254;
            stock2 = 8'd254;
            stock3 = 8'd254;
            stock4 = 8'd255;
            stock5 = 8'd254;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Stock 5 is the highest return", test_num);
            stock1 = 8'd1;
            stock2 = 8'd2;
            stock3 = 8'd3;
            stock4 = 8'd4;
            stock5 = 8'd5;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: All stocks have equal returns", test_num);
            stock1 = 8'd100;
            stock2 = 8'd100;
            stock3 = 8'd100;
            stock4 = 8'd100;
            stock5 = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: All stocks have zero return", test_num);
            stock1 = 8'd0;
            stock2 = 8'd0;
            stock3 = 8'd0;
            stock4 = 8'd0;
            stock5 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Multiple stocks share the highest return", test_num);
            stock1 = 8'd150;
            stock2 = 8'd220;
            stock3 = 8'd220;
            stock4 = 8'd100;
            stock5 = 8'd220;
            #1;

            check_outputs(8'd220);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [7:0] expected_max_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_return === (expected_max_return ^ max_return ^ expected_max_return)) begin
                $display("PASS");
                $display("  Outputs: max_return=%h",
                         max_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_return=%h",
                         expected_max_return);
                $display("  Got:      max_return=%h",
                         max_return);
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
