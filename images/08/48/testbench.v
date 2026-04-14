`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg [3:0] data_in;
    reg read_en;
    reg write_en;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_en = 0;
        forever #5 read_en = ~read_en;
    end

        task reset_dut;

        begin
            addr = 2'b00;
            data_in = 4'h0;
            write_en = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Address 0", test_num);
            addr = 2'b00;
            data_in = 4'hA;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Address 1", test_num);
            addr = 2'b01;
            data_in = 4'h5;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Address 2", test_num);
            addr = 2'b10;
            data_in = 4'hF;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #5;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Address 3", test_num);
            addr = 2'b11;
            data_in = 4'h0;
            write_en = 1;
            #10;
            write_en = 0;
            #10;
            #5;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Overwrite Address 0", test_num);

            addr = 2'b00; data_in = 4'h7; write_en = 1; #10;

            addr = 2'b00; data_in = 4'h3; write_en = 1; #10;
            write_en = 0;
            #15;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address Isolation", test_num);

            addr = 2'b01; data_in = 4'hB; write_en = 1; #10;

            addr = 2'b10; data_in = 4'h4; write_en = 1; #10;

            write_en = 0;
            addr = 2'b01;
            #15;
            #1;

            check_outputs(4'hB);
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
        $dumpvars(0,addr, data_in, read_en, write_en, data_out);
    end

endmodule
