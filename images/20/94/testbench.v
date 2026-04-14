`timescale 1ns/1ps

module mux_4to1_forward_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [1:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_forward dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test 001: Select in0");
            test_num = 1;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Select in1");
            test_num = 2;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Select in2");
            test_num = 3;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Select in3");
            test_num = 4;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b11;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Data Forwarding - New input matches previous output");

            test_num = 5;
            in0 = 8'h44;
            sel = 2'b00;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Selected input changes value");
            test_num = 6;
            sel = 2'b01;
            in1 = 8'hA5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Multiple inputs match, select change");
            test_num = 7;
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Boundary values");
            test_num = 8;
            in0 = 8'h00; in1 = 8'hFF; in2 = 8'h55; in3 = 8'hAA;
            sel = 2'b11;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: Quick switching between all channels");
            test_num = 9;
            in0 = 8'h01; in1 = 8'h02; in2 = 8'h03; in3 = 8'h04;

            sel = 2'b00; #5;
            sel = 2'b01; #5;
            sel = 2'b10; #5;
            sel = 2'b11;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase010;

        begin
            $display("Test 010: Data Forwarding - Input changes to match previous");
            test_num = 10;

            sel = 2'b00;
            in0 = 8'h04;
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_forward Testbench");
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
