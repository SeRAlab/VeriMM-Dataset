`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            write_enable = 0;
            data_in = 0;
            addr = 0;
            @(posedge clk);

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                addr = i;
                data_in = 8'h00;
                write_enable = 1;
                @(posedge clk);
            end
            #1 write_enable = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(negedge clk);
            addr = 3'b000;
            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);


            #1;
            write_enable = 0;
            addr = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write/Read at Address 7", test_num);


            @(negedge clk);
            addr = 3'b111;
            data_in = 8'h55;
            write_enable = 1;
            @(posedge clk);


            #1;
            write_enable = 0;
            addr = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Address Independence Check", test_num);


            @(negedge clk);
            addr = 3'b001;
            data_in = 8'hAA;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            addr = 3'b010;
            data_in = 8'hBB;
            write_enable = 1;
            @(posedge clk);


            #1;
            write_enable = 0;
            addr = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable Verification", test_num);


            @(negedge clk);
            addr = 3'b100;
            data_in = 8'hFF;
            write_enable = 0;
            @(posedge clk);


            #1;
            addr = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data Overwrite Check", test_num);


            @(negedge clk);
            addr = 3'b011;
            data_in = 8'h11;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 8'h22;
            @(posedge clk);


            #1;
            write_enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
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
        $dumpvars(0,addr, clk, data_in, write_enable, data_out);
    end

endmodule
