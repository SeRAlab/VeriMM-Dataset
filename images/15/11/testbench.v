`timescale 1ns/1ps

module eeprom_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg erase_enable;
    reg read_enable;
    reg write_enable;
    wire busy;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom dut (
        .data_in(data_in),
        .erase_enable(erase_enable),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        erase_enable = 0;
        forever #5 erase_enable = ~erase_enable;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            write_enable = 0;
            read_enable = 0;



            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'hA and Read", test_num);
            reset_dut();


            data_in = 4'hA;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;


            read_enable = 1;
            #5;
            #1;

            check_outputs(1'b1, 4'hA);
            read_enable = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write 4'h5, Erase, and Read", test_num);
            reset_dut();


            data_in = 4'h5;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;




            erase_enable = 1;
            #10;
            erase_enable = 0;
            #10;


            read_enable = 1;
            #5;
            #1;

            check_outputs(1'b1, 4'h0);
            read_enable = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite 4'hF with 4'h3", test_num);
            reset_dut();


            data_in = 4'hF;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;


            data_in = 4'h3;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;


            read_enable = 1;
            #5;
            #1;

            check_outputs(1'b1, 4'h3);
            read_enable = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Busy signal during Write", test_num);
            reset_dut();

            data_in = 4'h7;
            write_enable = 1;
            #5;

            #1;


            check_outputs(1'b1, data_out);
            write_enable = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Operation Sequence", test_num);
            reset_dut();


            data_in = 4'h9;
            write_enable = 1;
            #10;
            write_enable = 0;
            #10;


            read_enable = 1;
            #10;
            read_enable = 0;
            #10;


            read_enable = 1;
            #5;
            #1;

            check_outputs(1'b1, 4'h9);
            read_enable = 0;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom Testbench");
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
        input expected_busy;
        input [3:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,data_in, erase_enable, read_enable, write_enable, busy, data_out);
    end

endmodule
