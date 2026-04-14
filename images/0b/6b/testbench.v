`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
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
            address = 4'h0;
            data_in = 16'h0;
            write_enable = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read at Addr 0x0", test_num);

            address = 4'h0;
            data_in = 16'hA5A5;
            write_enable = 1;
            #10;
            write_enable = 0;


            address = 4'h0;
            @(posedge read_enable);
            #2;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write/Read at Boundary Addr 0xF", test_num);

            address = 4'hF;
            data_in = 16'h5A5A;
            write_enable = 1;
            #10;
            write_enable = 0;

            address = 4'hF;
            @(posedge read_enable);
            #2;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite check at Addr 0x5", test_num);


            address = 4'h5;
            data_in = 16'h1111;
            write_enable = 1;
            #10;

            data_in = 16'hFFFF;
            #10;
            write_enable = 0;

            address = 4'h5;
            @(posedge read_enable);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Cross-address persistence check", test_num);


            address = 4'h2;
            data_in = 16'hBEEF;
            write_enable = 1;
            #10;

            address = 4'h3;
            data_in = 16'hDEAD;
            #10;
            write_enable = 0;


            address = 4'h2;
            @(posedge read_enable);
            #2;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable gating check", test_num);


            address = 4'h8;
            data_in = 16'h1234;
            write_enable = 1;
            #10;

            write_enable = 0;
            data_in = 16'h9999;
            #10;

            address = 4'h8;
            @(posedge read_enable);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [15:0] expected_data_out;
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
