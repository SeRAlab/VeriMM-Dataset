`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P00;
    reg [7:0] P01;
    reg [7:0] P10;
    reg [7:0] P11;
    wire [7:0] P_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .P00(P00),
        .P01(P01),
        .P10(P10),
        .P11(P11),
        .P_out(P_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros", test_num);
        P00 = 8'd0; P01 = 8'd0; P10 = 8'd0; P11 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All maximum values", test_num);
        P00 = 8'hFF; P01 = 8'hFF; P10 = 8'hFF; P11 = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identical mid-range values", test_num);
        P00 = 8'd128; P01 = 8'd128; P10 = 8'd128; P11 = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple gradient (Exact division)", test_num);
        P00 = 8'd10; P01 = 8'd20; P10 = 8'd30; P11 = 8'd40;

        #1;


        check_outputs(8'd25);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: One pixel dominant (Truncation check)", test_num);
        P00 = 8'd255; P01 = 8'd0; P10 = 8'd0; P11 = 8'd0;

        #1;


        check_outputs(8'd63);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal variation", test_num);
        P00 = 8'd0; P01 = 8'd255; P10 = 8'd0; P11 = 8'd255;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Vertical variation", test_num);
        P00 = 8'd200; P01 = 8'd200; P10 = 8'd100; P11 = 8'd100;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard pattern", test_num);
        P00 = 8'd255; P01 = 8'd0; P10 = 8'd0; P11 = 8'd255;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Low intensity values", test_num);
        P00 = 8'd1; P01 = 8'd1; P10 = 8'd1; P11 = 8'd2;

        #1;


        check_outputs(8'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed values near overflow", test_num);
        P00 = 8'd240; P01 = 8'd250; P10 = 8'd230; P11 = 8'd220;

        #1;


        check_outputs(8'd235);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interpolation Testbench");
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
        input [7:0] expected_P_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P_out === (expected_P_out ^ P_out ^ expected_P_out)) begin
                $display("PASS");
                $display("  Outputs: P_out=%h",
                         P_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P_out=%h",
                         expected_P_out);
                $display("  Got:      P_out=%h",
                         P_out);
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
