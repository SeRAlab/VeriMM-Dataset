`timescale 1ns/1ps

module BilinearInterpolation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] P00;
    reg [15:0] P01;
    reg [15:0] P10;
    reg [15:0] P11;
    reg [15:0] Xfrac;
    reg [15:0] Yfrac;
    wire [15:0] Pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BilinearInterpolation dut (
        .P00(P00),
        .P01(P01),
        .P10(P10),
        .P11(P11),
        .Xfrac(Xfrac),
        .Yfrac(Yfrac),
        .Pout(Pout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Corner P00 (0.0, 0.0)");
        P00 = 16'h1111; P10 = 16'h2222; P01 = 16'h3333; P11 = 16'h4444;
        Xfrac = 16'h0000; Yfrac = 16'h0000;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Corner P10 (1.0, 0.0)");
        P00 = 16'h1111; P10 = 16'h2222; P01 = 16'h3333; P11 = 16'h4444;
        Xfrac = 16'h0100; Yfrac = 16'h0000;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Corner P01 (0.0, 1.0)");
        P00 = 16'h1111; P10 = 16'h2222; P01 = 16'h3333; P11 = 16'h4444;
        Xfrac = 16'h0000; Yfrac = 16'h0100;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Corner P11 (1.0, 1.0)");
        P00 = 16'h1111; P10 = 16'h2222; P01 = 16'h3333; P11 = 16'h4444;
        Xfrac = 16'h0100; Yfrac = 16'h0100;
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Center Point (0.5, 0.5)");
        P00 = 16'd100; P10 = 16'd200; P01 = 16'd300; P11 = 16'd400;
        Xfrac = 16'h0080; Yfrac = 16'h0080;

        #1;


        check_outputs(16'd250);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Horizontal Mid-edge (0.5, 0.0)");
        P00 = 16'd100; P10 = 16'd200; P01 = 16'd300; P11 = 16'd400;
        Xfrac = 16'h0080; Yfrac = 16'h0000;
        #1;

        check_outputs(16'd150);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Vertical Mid-edge (0.0, 0.5)");
        P00 = 16'd100; P10 = 16'd200; P01 = 16'd300; P11 = 16'd400;
        Xfrac = 16'h0000; Yfrac = 16'h0080;
        #1;

        check_outputs(16'd200);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Complex Interpolation (0.25, 0.75)");
        P00 = 16'h0000; P10 = 16'h0100; P01 = 16'h0200; P11 = 16'h0400;
        Xfrac = 16'h0040;
        Yfrac = 16'h00C0;




        #1;





        check_outputs(16'h01F0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Uniform Grid");
        P00 = 16'hAAAA; P10 = 16'hAAAA; P01 = 16'hAAAA; P11 = 16'hAAAA;
        Xfrac = 16'h0055; Yfrac = 16'h00AA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Precision Check (Near Boundary)");
        P00 = 16'h0000; P10 = 16'h0000; P01 = 16'h0000; P11 = 16'h1000;
        Xfrac = 16'h00FF;
        Yfrac = 16'h00FF;

        #1;


        check_outputs(16'h0FE0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BilinearInterpolation Testbench");
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
        input [15:0] expected_Pout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Pout === (expected_Pout ^ Pout ^ expected_Pout)) begin
                $display("PASS");
                $display("  Outputs: Pout=%h",
                         Pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Pout=%h",
                         expected_Pout);
                $display("  Got:      Pout=%h",
                         Pout);
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
