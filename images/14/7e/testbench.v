`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg sel0;
    reg sel1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Data0", test_num);

            data0 = 8'hAA; data1 = 8'hBB; data2 = 8'hCC; data3 = 8'hDD;
            sel1 = 0; sel0 = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Data1", test_num);
            data0 = 8'h11; data1 = 8'h22; data2 = 8'h33; data3 = 8'h44;
            sel1 = 0; sel0 = 1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Data2", test_num);
            data0 = 8'h01; data1 = 8'h02; data2 = 8'h03; data3 = 8'h04;
            sel1 = 1; sel0 = 0;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Data3", test_num);
            data0 = 8'hF0; data1 = 8'hF1; data2 = 8'hF2; data3 = 8'hF3;
            sel1 = 1; sel0 = 1;
            #1;

            check_outputs(8'hF3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change data on active selection", test_num);

            sel1 = 0; sel0 = 0;
            data0 = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Forwarding - Same as previous output", test_num);

            data1 = 8'h99;
            sel1 = 0; sel0 = 1;
            #5;



            data2 = 8'h99;
            sel1 = 1; sel0 = 0;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid input data switching", test_num);
            sel1 = 1; sel0 = 1;
            data3 = 8'h10; #2;
            data3 = 8'h20; #2;
            data3 = 8'h30; #2;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs same value", test_num);
            data0 = 8'hFF; data1 = 8'hFF; data2 = 8'hFF; data3 = 8'hFF;
            sel1 = 0; sel0 = 0; #2;
            sel1 = 1; sel0 = 1; #2;
            #1;

            check_outputs(8'hFF);
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
