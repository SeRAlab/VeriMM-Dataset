`timescale 1ns/1ps

module EEPROM_Cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EEPROM_Cell dut (
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Write and Hold 0xAA", test_num);

            write_enable = 0;
            data_in = 8'h00;
            #10;

            write_enable = 1;
            data_in = 8'hAA;
            #10;

            write_enable = 0;
            data_in = 8'hFF;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Write and Hold 0x55", test_num);

            write_enable = 0;
            data_in = 8'h00;
            #10;

            write_enable = 1;
            data_in = 8'h55;
            #10;

            write_enable = 0;
            data_in = 8'h00;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Verify Persistence (Ignore data_in when WE=0)", test_num);

            write_enable = 0;
            data_in = 8'h00;
            #10;

            write_enable = 1;
            data_in = 8'h33;
            #10;

            write_enable = 0;
            #10;

            data_in = 8'h11; #5;
            data_in = 8'h22; #5;
            data_in = 8'h44; #5;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Write Boundary Value 0x00", test_num);

            write_enable = 0;
            data_in = 8'hFF;
            #10;

            write_enable = 1;
            data_in = 8'h00;
            #10;

            write_enable = 0;
            data_in = 8'hFF;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Write Boundary Value 0xFF", test_num);

            write_enable = 0;
            data_in = 8'h00;
            #10;

            write_enable = 1;
            data_in = 8'hFF;
            #10;

            write_enable = 0;
            data_in = 8'h00;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Successive Writes", test_num);

            write_enable = 0;
            data_in = 8'h00;
            #10;

            write_enable = 1;
            data_in = 8'h12;
            #10;

            data_in = 8'h34;
            #10;

            data_in = 8'h56;
            #10;

            write_enable = 0;
            data_in = 8'h00;
            #10;
            #1;

            check_outputs(8'h56);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EEPROM_Cell Testbench");
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
