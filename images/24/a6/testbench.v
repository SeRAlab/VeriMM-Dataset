`timescale 1ns/1ps

module data_bus_controller_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_bus_controller dut (
        .control(control),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select Data Input 1 (Control=1)", test_num);
        control = 1'b1;
        data_in1 = 8'hAA;
        data_in2 = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select Data Input 2 (Control=0)", test_num);
        control = 1'b0;
        data_in1 = 8'hAA;
        data_in2 = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary - All Ones on Input 1", test_num);
        control = 1'b1;
        data_in1 = 8'hFF;
        data_in2 = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary - All Zeros on Input 2", test_num);
        control = 1'b0;
        data_in1 = 8'hFF;
        data_in2 = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Pattern Check (Alternating Bits)", test_num);
        control = 1'b1;
        data_in1 = 8'b10101010;
        data_in2 = 8'b01010101;
        #1;

        check_outputs(8'b10101010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Switching Control with same inputs", test_num);
        data_in1 = 8'hC3;
        data_in2 = 8'h3C;

        control = 1'b1;
        #1;
        control = 1'b0;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_bus_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
