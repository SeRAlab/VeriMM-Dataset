`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg read_en;
    reg write_en;
    wire [15:0] data_out;

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
            addr = 0;
            data_in = 0;
            write_en = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read at Addr 0", test_num);
            addr = 4'h0;
            data_in = 16'hAAAA;
            write_en = 1;
            #10;
            write_en = 0;
            addr = 4'h0;
            #7;
            #1;

            check_outputs(16'hAAAA);
            #3;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Address 15", test_num);
            addr = 4'hF;
            data_in = 16'h5555;
            write_en = 1;
            #10;
            write_en = 0;
            addr = 4'hF;
            #7;
            #1;

            check_outputs(16'h5555);
            #3;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwrite Data at Addr 5", test_num);

            addr = 4'h5;
            data_in = 16'h1234;
            write_en = 1;
            #10;

            data_in = 16'h4321;
            #10;
            write_en = 0;
            addr = 4'h5;
            #7;
            #1;

            check_outputs(16'h4321);
            #3;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data isolation (Addr 2 vs Addr 3)", test_num);

            addr = 4'h2;
            data_in = 16'h1111;
            write_en = 1;
            #10;

            addr = 4'h3;
            data_in = 16'h2222;
            write_en = 1;
            #10;
            write_en = 0;

            addr = 4'h2;
            #7;
            #1;

            check_outputs(16'h1111);
            #3;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write All Zeros", test_num);
            addr = 4'hA;
            data_in = 16'h0000;
            write_en = 1;
            #10;
            write_en = 0;
            addr = 4'hA;
            #7;
            #1;

            check_outputs(16'h0000);
            #3;
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
        $dumpvars(0,addr, data_in, read_en, write_en, data_out);
    end

endmodule
