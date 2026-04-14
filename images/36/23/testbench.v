`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg ce;
    reg [3:0] data_in;
    reg oe;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .ce(ce),
        .data_in(data_in),
        .oe(oe),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        ce = 0;
        forever #5 ce = ~ce;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            oe = 0;
            we = 0;

            @(posedge ce);
            @(posedge ce);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Writing 4'hA to Addr 0 and Reading back", test_num);


            @(negedge ce);
            addr = 2'b00;
            data_in = 4'hA;
            we = 1;
            oe = 0;

            @(negedge ce);
            we = 0;


            addr = 2'b00;
            oe = 1;

            @(posedge ce);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Writing 4'h5 to Addr 3 and Reading back", test_num);


            @(negedge ce);
            addr = 2'b11;
            data_in = 4'h5;
            we = 1;
            oe = 0;

            @(negedge ce);
            we = 0;


            addr = 2'b11;
            oe = 1;

            @(posedge ce);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Verifying all 4 addresses retain unique data", test_num);


            @(negedge ce);
            we = 1; oe = 0;
            addr = 2'b00; data_in = 4'h1; @(negedge ce);
            addr = 2'b01; data_in = 4'h2; @(negedge ce);
            addr = 2'b10; data_in = 4'h4; @(negedge ce);
            addr = 2'b11; data_in = 4'h8; @(negedge ce);

            we = 0;


            addr = 2'b01;
            oe = 1;
            @(posedge ce);
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Verifying oe=0 results in high-impedance", test_num);


            @(negedge ce);
            addr = 2'b10;
            data_in = 4'hC;
            we = 1;
            @(negedge ce);
            we = 0;


            addr = 2'b10;
            oe = 0;
            @(posedge ce);
            #1;
            #1;

            check_outputs(4'bz);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Verifying no write occurs when we=0", test_num);


            @(negedge ce);
            addr = 2'b00;
            data_in = 4'hF;
            we = 1;
            @(negedge ce);


            we = 0;
            data_in = 4'h0;
            @(negedge ce);


            oe = 1;
            @(posedge ce);
            #1;
            #1;

            check_outputs(4'hF);
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
        $dumpvars(0,addr, ce, data_in, oe, we, data_out);
    end

endmodule
