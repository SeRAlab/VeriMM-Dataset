`timescale 1ns/1ps

module dram_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg clock;
    reg [3:0] data_in;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_4bit dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            write_enable = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write and Read Address 0", test_num);
            reset_dut();


            address = 2'b00;
            data_in = 4'hA;
            write_enable = 1;
            @(posedge clock);
            #2;
            write_enable = 0;


            @(negedge clock);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write and Read Address 3", test_num);
            reset_dut();


            address = 2'b11;
            data_in = 4'h5;
            write_enable = 1;
            @(posedge clock);
            #2;
            write_enable = 0;


            @(negedge clock);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Memory Persistence", test_num);
            reset_dut();


            address = 2'b01;
            data_in = 4'h7;
            write_enable = 1;
            @(posedge clock);


            address = 2'b10;
            data_in = 4'hE;
            @(posedge clock);
            #2;
            write_enable = 0;


            address = 2'b01;
            @(negedge clock);
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Check", test_num);
            reset_dut();


            address = 2'b00;
            data_in = 4'hF;
            write_enable = 1;
            @(posedge clock);


            write_enable = 0;
            data_in = 4'h0;
            @(posedge clock);


            @(negedge clock);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Existing Data", test_num);
            reset_dut();


            address = 2'b10;
            data_in = 4'h1;
            write_enable = 1;
            @(posedge clock);


            data_in = 4'hC;
            @(posedge clock);
            #2;
            write_enable = 0;


            @(negedge clock);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_4bit Testbench");
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
        $dumpvars(0,address, clock, data_in, write_enable, data_out);
    end

endmodule
