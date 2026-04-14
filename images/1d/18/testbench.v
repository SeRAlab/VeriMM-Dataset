`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] Ixy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .I00(I00),
        .I01(I01),
        .I10(I10),
        .I11(I11),
        .x(x),
        .y(y),
        .Ixy(Ixy)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bottom-Left Corner (x=0.0, y=0.0)", test_num);
        I00 = 8'd100; I01 = 8'd50; I10 = 8'd200; I11 = 8'd150;
        x = 8'h00;
        y = 8'h00;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bottom-Right Corner (x=1.0, y=0.0)", test_num);
        I00 = 8'd100; I01 = 8'd50; I10 = 8'd200; I11 = 8'd150;
        x = 8'h10;
        y = 8'h00;

        #1;


        check_outputs(8'd200);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Top-Left Corner (x=0.0, y=1.0)", test_num);
        I00 = 8'd100; I01 = 8'd50; I10 = 8'd200; I11 = 8'd150;
        x = 8'h00;
        y = 8'h10;

        #1;


        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Top-Right Corner (x=1.0, y=1.0)", test_num);
        I00 = 8'd100; I01 = 8'd50; I10 = 8'd200; I11 = 8'd150;
        x = 8'h10;
        y = 8'h10;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Center point (x=0.5, y=0.5)", test_num);
        I00 = 8'd10; I01 = 8'd20; I10 = 8'd30; I11 = 8'd40;
        x = 8'h08;
        y = 8'h08;

        #1;


        check_outputs(8'd25);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Horizontal Midpoint (x=0.5, y=0.0)", test_num);
        I00 = 8'd0; I01 = 8'd255; I10 = 8'd255; I11 = 8'd0;
        x = 8'h08;
        y = 8'h00;


        #1;



        check_outputs(8'd127);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Vertical Quarter-point (x=0.0, y=0.25)", test_num);
        I00 = 8'd100; I01 = 8'd200; I10 = 8'd0; I11 = 8'd0;
        x = 8'h00;
        y = 8'h04;

        #1;


        check_outputs(8'd125);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Intensity", test_num);
        I00 = 8'd255; I01 = 8'd255; I10 = 8'd255; I11 = 8'd255;
        x = 8'h04; y = 8'h0C;

        #1;


        check_outputs(8'd255);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Near Corner (x=0.125, y=0.125)", test_num);
        I00 = 8'd255; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;
        x = 8'h02;
        y = 8'h02;



        #1;




        check_outputs(8'd195);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Intensity", test_num);
        I00 = 8'd0; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;
        x = 8'h0F; y = 8'h0F;

        #1;


        check_outputs(8'd0);
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
        input [7:0] expected_Ixy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Ixy === (expected_Ixy ^ Ixy ^ expected_Ixy)) begin
                $display("PASS");
                $display("  Outputs: Ixy=%h",
                         Ixy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ixy=%h",
                         expected_Ixy);
                $display("  Got:      Ixy=%h",
                         Ixy);
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
