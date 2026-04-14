`timescale 1ns/1ps

module EEPROM_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg er;
    reg re;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EEPROM dut (
        .data_in(data_in),
        .er(er),
        .re(re),
        .we(we),
        .data_out(data_out)
    );
    task reset_eeprom;

    begin
        er = 1;
        we = 0;
        re = 0;
        data_in = 4'h0;
        #10;
        er = 0;
        #10;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Erase Operation (Default state check)", test_num);

        reset_eeprom();

        re = 1;
        #10;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Write and Read Operation", test_num);
        reset_eeprom();

        data_in = 4'hA;
        we = 1;
        #10;
        we = 0;
        #10;

        re = 1;
        #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Write Enable (WE) validation", test_num);
        reset_eeprom();

        data_in = 4'h5;
        we = 0;
        #10;

        re = 1;
        #10;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Read Enable (RE) validation", test_num);
        reset_eeprom();

        data_in = 4'h7;
        we = 1;
        #10;
        we = 0;

        re = 0;
        #10;


        #1;



        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Erase priority/sequence check", test_num);
        reset_eeprom();

        data_in = 4'h3;
        we = 1;
        #10;
        we = 0;

        er = 1;
        #10;
        er = 0;

        re = 1;
        #10;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Data retention check (Overwrite)", test_num);
        reset_eeprom();

        data_in = 4'hC;
        we = 1;
        #10;
        we = 0;

        data_in = 4'h9;
        we = 1;
        #10;
        we = 0;

        re = 1;
        #10;
        #1;

        check_outputs(4'h9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EEPROM Testbench");
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
        input [3:0] expected_data_out;
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
