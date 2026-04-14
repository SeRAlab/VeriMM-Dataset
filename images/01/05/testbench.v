`timescale 1ns/1ps

module bilinear_interp_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P00;
    reg [7:0] P01;
    reg [7:0] P10;
    reg [7:0] P11;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interp dut (
        .P00(P00),
        .P01(P01),
        .P10(P10),
        .P11(P11),
        .x(x),
        .y(y),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h00;
        y = 8'h00;
        $display("Test %0d: Top-left corner (0.0, 0.0)", test_num);
        #1;

        check_outputs(16'h0A00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h08;
        y = 8'h08;
        $display("Test %0d: Center (0.5, 0.5)", test_num);
        #1;

        check_outputs(16'h1900);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h0F;
        y = 8'h0F;
        $display("Test %0d: Near Bottom-Right (15/16, 15/16)", test_num);


        #1;



        check_outputs(16'h2620);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        P00 = 8'hFF; P10 = 8'hFF;
        P01 = 8'hFF; P11 = 8'hFF;
        x = 8'h04;
        y = 8'h0C;
        $display("Test %0d: Maximum Pixel Values", test_num);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h08;
        y = 8'h00;
        $display("Test %0d: Horizontal Interp Only (y=0)", test_num);

        #1;


        check_outputs(16'h1400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h00;
        y = 8'h08;
        $display("Test %0d: Vertical Interp Only (x=0)", test_num);

        #1;


        check_outputs(16'h0F00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        P00 = 8'd10; P10 = 8'd30;
        P01 = 8'd20; P11 = 8'd40;
        x = 8'h23;
        y = 8'h45;
        $display("Test %0d: Fixed-point coordinate with non-zero Integer Part", test_num);


        #1;



        check_outputs(16'h10E0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interp Testbench");
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
        input [15:0] expected_out;
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
