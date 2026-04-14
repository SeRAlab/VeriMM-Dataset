`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg erase_enable;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .data_in(data_in),
        .erase_enable(erase_enable),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_enable = 0;
        forever #5 read_enable = ~read_enable;
    end

        task reset_dut;

    begin
        data_in = 4'b0000;
        write_enable = 0;
        erase_enable = 1;
        #10;
        erase_enable = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();

        data_in = 4'hA;
        write_enable = 1;
        #10;
        write_enable = 0;


        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Erase Operation", test_num);
        reset_dut();


        data_in = 4'hF;
        write_enable = 1;
        #10;
        write_enable = 0;


        erase_enable = 1;
        #10;
        erase_enable = 0;

        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Write vs Erase)", test_num);
        reset_dut();


        data_in = 4'h7;
        write_enable = 1;
        erase_enable = 1;
        #10;
        write_enable = 0;
        erase_enable = 0;

        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Retention", test_num);
        reset_dut();


        data_in = 4'hC;
        write_enable = 1;
        #10;
        write_enable = 0;


        data_in = 4'h0;
        #20;

        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwriting Existing Data", test_num);
        reset_dut();


        data_in = 4'h1;
        write_enable = 1;
        #10;


        data_in = 4'hB;
        #10;
        write_enable = 0;

        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read Enable Sensitivity", test_num);
        reset_dut();

        data_in = 4'h5;
        write_enable = 1;
        #10;
        write_enable = 0;


        wait(read_enable == 0);
        #2;


        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,data_in, erase_enable, read_enable, write_enable, data_out);
    end

endmodule
