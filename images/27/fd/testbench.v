`timescale 1ns/1ps

module flash_memory_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg reset;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset functionality", test_num);
            reset_dut();


            addr = 2'b10;
            enable = 0;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write to addr 0 and read back", test_num);
            reset_dut();


            addr = 2'b00;
            data_in = 4'h5;
            enable = 1;
            @(posedge clk);


            #1 enable = 0;
            addr = 2'b00;
            #10;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple writes (address 1 and 3)", test_num);
            reset_dut();


            addr = 2'b01;
            data_in = 4'hA;
            enable = 1;
            @(posedge clk);


            #1 addr = 2'b11;
            data_in = 4'hF;
            @(posedge clk);


            #1 enable = 0;
            addr = 2'b11;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence check", test_num);
            reset_dut();


            addr = 2'b10;
            data_in = 4'hC;
            enable = 1;
            @(posedge clk);


            #1 addr = 2'b00;
            data_in = 4'h3;
            @(posedge clk);


            #1 enable = 0;
            addr = 2'b10;
            #10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write operation when enable is low", test_num);
            reset_dut();


            addr = 2'b01;
            data_in = 4'h9;
            enable = 0;
            @(posedge clk);


            #1 addr = 2'b01;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite memory cell", test_num);
            reset_dut();


            addr = 2'b11;
            data_in = 4'h2;
            enable = 1;
            @(posedge clk);


            #1 data_in = 4'hE;
            @(posedge clk);


            #1 enable = 0;
            addr = 2'b11;
            #10;
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_controller Testbench");
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
        $dumpvars(0,addr, clk, data_in, enable, reset, data_out);
    end

endmodule
