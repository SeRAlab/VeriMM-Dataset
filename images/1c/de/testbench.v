`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [2:0] scale_ctrl;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .data_in(data_in),
        .scale_ctrl(scale_ctrl),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 8'h00;
        scale_ctrl = 3'b000;
        $display("Test %0d: Scale 1x, Input 0x00", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 8'h7F;
        scale_ctrl = 3'b000;
        $display("Test %0d: Scale 1x, Input 0x7F", test_num);
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 8'hFF;
        scale_ctrl = 3'b000;
        $display("Test %0d: Scale 1x, Input 0xFF", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 8'd50;
        scale_ctrl = 3'b001;
        $display("Test %0d: Scale 2x, Input 50", test_num);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 8'd127;
        scale_ctrl = 3'b001;
        $display("Test %0d: Scale 2x, Input 127", test_num);
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 8'd128;
        scale_ctrl = 3'b001;
        $display("Test %0d: Scale 2x, Input 128 (Saturation Check)", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 8'd25;
        scale_ctrl = 3'b010;
        $display("Test %0d: Scale 4x, Input 25", test_num);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 8'd63;
        scale_ctrl = 3'b010;
        $display("Test %0d: Scale 4x, Input 63", test_num);
        #1;

        check_outputs(8'd252);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 8'd64;
        scale_ctrl = 3'b010;
        $display("Test %0d: Scale 4x, Input 64 (Saturation Check)", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 8'hFF;
        scale_ctrl = 3'b010;
        $display("Test %0d: Scale 4x, Input 255 (Heavy Saturation)", test_num);
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
        $display("DAC Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
