`timescale 1ns/1ps

module eeprom_interface_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] address;
    reg [4:0] data_in;
    reg we;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_interface dut (
        .address(address),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read (Addr: 0x05, Data: 0x0A)", test_num);


        address = 5'h05;
        data_in = 5'h0A;
        we = 1;
        #10;


        we = 0;
        #10;


        #1;



        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Write and Read (Addr: 0x1F, Data: 0x1F)", test_num);


        address = 5'h1F;
        data_in = 5'h1F;
        we = 1;
        #10;


        we = 0;
        #10;

        #1;


        check_outputs(5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite existing address (Addr: 0x0A, 0x01 -> 0x12)", test_num);


        address = 5'h0A;
        data_in = 5'h01;
        we = 1;
        #10;


        data_in = 5'h12;
        #10;


        we = 0;
        #10;

        #1;


        check_outputs(5'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Write Enable (we=0 should not update memory)", test_num);


        address = 5'h02;
        data_in = 5'h0F;
        we = 1;
        #10;


        we = 0;
        data_in = 5'h15;
        #10;


        #1;



        check_outputs(5'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Persistence check across multiple addresses", test_num);


        address = 5'h01;
        data_in = 5'h11;
        we = 1;
        #10;


        address = 5'h02;
        data_in = 5'h12;
        we = 1;
        #10;


        we = 0;
        address = 5'h01;
        #10;

        #1;


        check_outputs(5'h11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_interface Testbench");
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
        input [4:0] expected_data_out;
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
