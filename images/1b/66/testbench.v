`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg [7:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
        .data_in(data_in),
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
            address = 0;
            data_in = 0;
            write_enable = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            address = 3'b000;
            data_in = 8'hA5;
            write_enable = 1;
            #10;
            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %0d: Multi-address Write and Read", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                address = i;
                data_in = i + 8'h10;
                write_enable = 1;
                #10;
            end
            write_enable = 0;


            for (i = 7; i >= 0; i = i - 1) begin
                address = i;
                wait(read_enable == 1);
                #2;
                #1;

                check_outputs(i + 8'h10);
                wait(read_enable == 0);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwrite Verification (Addr 4)", test_num);
            reset_dut();


            address = 3'h4;
            data_in = 8'hAA;
            write_enable = 1;
            #10;


            data_in = 8'h55;
            #10;
            write_enable = 0;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Passive Check", test_num);
            reset_dut();


            address = 3'h2;
            data_in = 8'hBE;
            write_enable = 1;
            #10;
            write_enable = 0;


            data_in = 8'hEF;
            #10;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Address Check (Addr 7)", test_num);
            reset_dut();

            address = 3'b111;
            data_in = 8'hFF;
            write_enable = 1;
            #10;
            write_enable = 0;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,address, data_in, read_enable, write_enable, data_out);
    end

endmodule
