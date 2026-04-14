`timescale 1ns/1ps

module mux_with_hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] data_in;
    reg [1:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_with_hazard_detection dut (
        .data_in(data_in),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select data_in[0] with value 1", test_num);
        data_in = 3'b001;
        sel = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select data_in[0] with value 0", test_num);
        data_in = 3'b110;
        sel = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select data_in[1] with value 1", test_num);
        data_in = 3'b010;
        sel = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select data_in[1] with value 0", test_num);
        data_in = 3'b101;
        sel = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Select data_in[2] with value 1", test_num);
        data_in = 3'b100;
        sel = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Select data_in[2] with value 0", test_num);
        data_in = 3'b011;
        sel = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Select invalid state (sel=2'b11)", test_num);
        data_in = 3'b111;
        sel = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Hazard Resolution - Transition 00 to 01 while both inputs are 1", test_num);

        data_in = 3'b011;
        sel = 2'b00;
        #5;
        sel = 2'b01;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Hazard Resolution - Transition 01 to 10 while both inputs are 1", test_num);
        data_in = 3'b110;
        sel = 2'b01;
        #5;
        sel = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Check all-zeros input", test_num);
        data_in = 3'b000;
        sel = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_with_hazard_detection Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
