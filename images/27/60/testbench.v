`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] coeff0;
    reg [4:0] coeff1;
    reg [4:0] coeff2;
    reg [4:0] coeff3;
    reg [4:0] coeff4;
    reg [4:0] x;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .coeff0(coeff0),
        .coeff1(coeff1),
        .coeff2(coeff2),
        .coeff3(coeff3),
        .coeff4(coeff4),
        .x(x),
        .y(y)
    );
    task reset_fir;

        begin
            x = 5'd0;
            coeff0 = 5'd0; coeff1 = 5'd0; coeff2 = 5'd0; coeff3 = 5'd0; coeff4 = 5'd0;
            #50;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros - Verifying Zero Initialization", test_num);
        reset_fir();

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Impulse Response - Verifying Tap Shifting", test_num);
        reset_fir();

        coeff0 = 5'd2; coeff1 = 5'd4; coeff2 = 5'd6; coeff3 = 5'd8; coeff4 = 5'd10;







        x = 5'd1; #10;
        x = 5'd0; #10;
        x = 5'd0; #10;
        x = 5'd0; #10;
        x = 5'd0; #10;

        #1;


        check_outputs(10'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Step Response - Verifying Accumulation", test_num);
        reset_fir();

        coeff0 = 5'd1; coeff1 = 5'd1; coeff2 = 5'd1; coeff3 = 5'd1; coeff4 = 5'd1;



        x = 5'd1; #10;
        x = 5'd1; #10;
        x = 5'd1; #10;
        x = 5'd1; #10;
        x = 5'd1; #10;

        #1;


        check_outputs(10'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Values - Verifying 10-bit Wrap/Truncation", test_num);
        reset_fir();

        coeff0 = 5'd31; coeff1 = 5'd31; coeff2 = 5'd31; coeff3 = 5'd31; coeff4 = 5'd31;





        x = 5'd31; #10;
        x = 5'd31; #10;
        x = 5'd31; #10;
        x = 5'd31; #10;
        x = 5'd31; #10;

        #1;


        check_outputs(10'h2C5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex Pattern", test_num);
        reset_fir();

        coeff0 = 5'd10; coeff1 = 5'd5; coeff2 = 5'd2; coeff3 = 5'd5; coeff4 = 5'd10;





        x = 5'd2; #10;
        x = 5'd4; #10;
        x = 5'd6; #10;
        x = 5'd4; #10;
        x = 5'd2; #10;

        #1;


        check_outputs(10'd92);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [9:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
