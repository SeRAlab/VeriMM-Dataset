`timescale 1ns/1ps

module mux_4to1_with_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg enable;
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
    mux_4to1_with_forwarding dut (
        .enable(enable),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Running testcase001: Enable=0, Sel=0");
            test_num = test_num + 1;
            enable = 0;
            in0 = 8'hAA; in1 = 8'hBB; in2 = 8'hCC; in3 = 8'hDD;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Enable=1, Sel=0 (Select In0)");
            test_num = test_num + 1;
            enable = 1;
            in0 = 8'h12; in1 = 8'h34; in2 = 8'h56; in3 = 8'h78;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable=1, Sel=1 (Select In1)");
            test_num = test_num + 1;
            enable = 1;
            in0 = 8'hA1; in1 = 8'hB2; in2 = 8'hC3; in3 = 8'hD4;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable=1, Sel=2 (Select In2)");
            test_num = test_num + 1;
            enable = 1;
            in0 = 8'h0F; in1 = 8'hF0; in2 = 8'h55; in3 = 8'hAA;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Enable=1, Sel=3 (Select In3)");
            test_num = test_num + 1;
            enable = 1;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Enable=0, Sel=3");
            test_num = test_num + 1;
            enable = 0;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'hFF;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Enable=1, Sel=2, In2=0");
            test_num = test_num + 1;
            enable = 1;
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'h00; in3 = 8'hFF;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Enable=1, Sel=1, In1=0xFF");
            test_num = test_num + 1;
            enable = 1;
            in1 = 8'hFF;
            sel = 2'b01;
            #10;
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
        $display("mux_4to1_with_forwarding Testbench");
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
