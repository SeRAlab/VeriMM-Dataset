`timescale 1ns/1ps

module sram_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_8bit dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 3'b0;
            data_in = 8'b0;
            we = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Write and Read", test_num);
            reset_dut();


            addr = 3'd2;
            data_in = 8'hA5;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            addr = 3'd2;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Boundary Address Read/Write (Addr 7)", test_num);
            reset_dut();


            addr = 3'd7;
            data_in = 8'h5A;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            addr = 3'd7;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Enable Verification", test_num);
            reset_dut();


            addr = 3'd4;
            data_in = 8'h11;
            we = 1;
            @(posedge clk);
            #2;


            addr = 3'd4;
            data_in = 8'hEE;
            we = 0;
            @(posedge clk);
            #2;


            addr = 3'd4;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overwrite Memory Location", test_num);
            reset_dut();


            addr = 3'd1;
            data_in = 8'hAA;
            we = 1;
            @(posedge clk);
            #2;


            addr = 3'd1;
            data_in = 8'hBB;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            addr = 3'd1;
            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data Patterns (0xFF and 0x00)", test_num);
            reset_dut();


            addr = 3'd0;
            data_in = 8'hFF;
            we = 1;
            @(posedge clk);
            #2;


            addr = 3'd3;
            data_in = 8'h00;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            addr = 3'd0;
            #2;

            if (data_out !== 8'hFF) begin
                #1;

                check_outputs(8'hFF);
            end else begin

                addr = 3'd3;
                #2;
                #1;

                check_outputs(8'h00);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_8bit Testbench");
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
