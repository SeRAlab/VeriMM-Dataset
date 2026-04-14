`timescale 1ns/1ps

module flash_memory_controller_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg erase_enable;
    reg write_enable;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_controller dut (
        .data_in(data_in),
        .erase_enable(erase_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write 5'h15", test_num);

        erase_enable = 1; write_enable = 0; data_in = 5'h00; #10;

        erase_enable = 0; write_enable = 1; data_in = 5'h15; #10;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Erase after Write", test_num);

        erase_enable = 0; write_enable = 1; data_in = 5'h1F; #10;

        erase_enable = 1; write_enable = 0; #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold previous value", test_num);

        erase_enable = 1; write_enable = 0; #10;

        erase_enable = 0; write_enable = 1; data_in = 5'h0A; #10;

        write_enable = 0; erase_enable = 0; data_in = 5'h1F; #10;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Writes", test_num);

        erase_enable = 1; write_enable = 0; #10;

        erase_enable = 0; write_enable = 1; data_in = 5'h05; #10;

        data_in = 5'h12; #10;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Erase priority over Write", test_num);

        erase_enable = 1; write_enable = 0; #10;

        erase_enable = 1; write_enable = 1; data_in = 5'h11; #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write boundary value 5'h1F", test_num);

        erase_enable = 1; write_enable = 0; #10;

        erase_enable = 0; write_enable = 1; data_in = 5'h1F; #10;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold then Erase", test_num);

        erase_enable = 1; write_enable = 0; #10;

        erase_enable = 0; write_enable = 1; data_in = 5'h0C; #10;

        write_enable = 0; #10;

        erase_enable = 1; #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
