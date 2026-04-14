`timescale 1ns/1ps

module output_select_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] out1;
    reg [7:0] out2;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    output_select dut (
        .out1(out1),
        .out2(out2),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            sel = 1'b0;
            out1 = 8'hAA;
            out2 = 8'h55;
            $display("Running Testcase %0d: Select out1 (sel=0)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sel = 1'b1;
            out1 = 8'hAA;
            out2 = 8'h55;
            $display("Running Testcase %0d: Select out2 (sel=1)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sel = 1'b0;
            out1 = 8'h00;
            out2 = 8'hFF;
            $display("Running Testcase %0d: Select out1 (All Zeros)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sel = 1'b1;
            out1 = 8'h00;
            out2 = 8'hFF;
            $display("Running Testcase %0d: Select out2 (All Ones)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sel = 1'b0;
            out1 = 8'h12;
            out2 = 8'h34;
            $display("Running Testcase %0d: Select out1 (0x12)", test_num);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            sel = 1'b1;
            out1 = 8'hDE;
            out2 = 8'hAD;
            $display("Running Testcase %0d: Select out2 (0xAD)", test_num);
            #1;

            check_outputs(8'hAD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 1'b0;
            out1 = 8'hBC;
            out2 = 8'h00;
            $display("Running Testcase %0d: verify transparency of out1", test_num);
            #1;

            check_outputs(8'hBC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sel = 1'b1;
            out1 = 8'h00;
            out2 = 8'hFE;
            $display("Running Testcase %0d: verify transparency of out2", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("output_select Testbench");
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
