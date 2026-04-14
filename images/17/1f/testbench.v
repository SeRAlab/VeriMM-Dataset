`timescale 1ns/1ps

module multiplexer_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplexer_2to1 dut (
        .data0(data0),
        .data1(data1),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select data0 (select = 0)", test_num);
        data0 = 8'hA5;
        data1 = 8'h5A;
        select = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select data1 (select = 1)", test_num);
        data0 = 8'hA5;
        data1 = 8'h5A;
        select = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Minimum boundary values, select data0", test_num);
        data0 = 8'h00;
        data1 = 8'hFF;
        select = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum boundary values, select data1", test_num);
        data0 = 8'h00;
        data1 = 8'hFF;
        select = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating pattern AA/55, select data0", test_num);
        data0 = 8'hAA;
        data1 = 8'h55;
        select = 1'b0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating pattern AA/55, select data1", test_num);
        data0 = 8'hAA;
        data1 = 8'h55;
        select = 1'b1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Walking bit select data1", test_num);
        data0 = 8'h00;
        data1 = 8'h80;
        select = 1'b1;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Identical inputs", test_num);
        data0 = 8'h3C;
        data1 = 8'h3C;
        select = 1'b0;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplexer_2to1 Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
