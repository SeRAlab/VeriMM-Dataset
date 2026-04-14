`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [2:0] data_in;
    wire [2:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Control 00 (No Shift) - Input 101");
            test_num = 1;
            control = 2'b00;
            data_in = 3'b101;
            #10;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Control 01 (1-bit Circular Right Shift) - Input 100");
            test_num = 2;
            control = 2'b01;
            data_in = 3'b100;
            #10;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Control 10 (2-bit Circular Right Shift) - Input 100");
            test_num = 3;
            control = 2'b10;
            data_in = 3'b100;
            #10;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Control 11 (3-bit Circular Right Shift/Identity) - Input 110");
            test_num = 4;
            control = 2'b11;
            data_in = 3'b110;
            #10;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Control 01 (1-bit Circular Right Shift) - Input 001");
            test_num = 5;
            control = 2'b01;
            data_in = 3'b001;
            #10;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Control 10 (2-bit Circular Right Shift) - Input 011");
            test_num = 6;
            control = 2'b10;
            data_in = 3'b011;
            #10;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Boundary Test - All Zeros");
            test_num = 7;
            control = 2'b01;
            data_in = 3'b000;
            #10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Boundary Test - All Ones");
            test_num = 8;
            control = 2'b10;
            data_in = 3'b111;
            #10;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [2:0] expected_data_out;
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
