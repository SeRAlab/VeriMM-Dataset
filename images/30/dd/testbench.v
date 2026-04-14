`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg ce;
    reg [7:0] data_in;
    reg rw;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .ce(ce),
        .data_in(data_in),
        .rw(rw),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        ce = 0;
        forever #5 ce = ~ce;
    end

        task reset_dut;

        begin
            rw = 0;
            addr = 0;
            data_in = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge ce);
            rw = 1;
            addr = 3'b000;
            data_in = 8'hA5;
            @(negedge ce);


            @(posedge ce);
            rw = 0;
            addr = 3'b000;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write/Read at Max Address", test_num);
            reset_dut();


            @(posedge ce);
            rw = 1;
            addr = 3'b111;
            data_in = 8'h5A;
            @(negedge ce);


            @(posedge ce);
            rw = 0;
            addr = 3'b111;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence/Address Independence", test_num);
            reset_dut();


            @(posedge ce);
            rw = 1; addr = 3'b001; data_in = 8'h11;
            @(negedge ce);


            @(posedge ce);
            rw = 1; addr = 3'b010; data_in = 8'h22;
            @(negedge ce);


            @(posedge ce);
            rw = 0; addr = 3'b001;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data", test_num);
            reset_dut();


            @(posedge ce);
            rw = 1; addr = 3'b011; data_in = 8'hCC;
            @(negedge ce);


            @(posedge ce);
            rw = 1; addr = 3'b011; data_in = 8'h33;
            @(negedge ce);


            @(posedge ce);
            rw = 0; addr = 3'b011;
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-address verification", test_num);


            reset_dut();

            @(posedge ce);
            rw = 1; addr = 3'b100; data_in = 8'hFF;
            @(negedge ce);

            @(posedge ce);
            rw = 0; addr = 3'b100;
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
        $dumpvars(0,addr, ce, data_in, rw, data_out);
    end

endmodule
