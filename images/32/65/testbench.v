`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
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
            addr = 4'b0;
            data_in = 16'b0;
            write_enable = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Addr 0", test_num);


            addr = 4'h0;
            data_in = 16'hAAAA;
            write_enable = 1;
            #10;


            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary Address Write and Read (Addr 15)", test_num);

            addr = 4'hF;
            data_in = 16'h5555;
            write_enable = 1;
            #10;

            write_enable = 0;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwriting data at Addr 5", test_num);


            addr = 4'h5;
            data_in = 16'h1234;
            write_enable = 1;
            #10;


            data_in = 16'hABCD;
            #10;

            write_enable = 0;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Address Independence Check", test_num);


            addr = 4'h1;
            data_in = 16'h1111;
            write_enable = 1;
            #10;


            addr = 4'h2;
            data_in = 16'h2222;
            write_enable = 1;
            #10;


            write_enable = 0;
            addr = 4'h1;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Writing and Reading Zero Value", test_num);

            addr = 4'hA;
            data_in = 16'h0000;
            write_enable = 1;
            #10;

            write_enable = 0;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(16'h0000);
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
        $dumpvars(0,addr, data_in, read_enable, write_enable, data_out);
    end

endmodule
