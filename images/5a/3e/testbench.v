`timescale 1ns/1ps

module memory_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [3:0] data_in;
    reg read_en;
    reg write_en;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
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
            data_in = 4'b0;
            read_en = 1'b0;
            write_en = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            @(negedge clk);
            addr = 3'h0;
            data_in = 4'hA;
            write_en = 1'b1;
            read_en = 1'b0;
            @(negedge clk);
            write_en = 1'b0;


            addr = 3'h0;
            read_en = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            @(negedge clk);
            addr = 3'h7;
            data_in = 4'h5;
            write_en = 1'b1;
            read_en = 1'b0;
            @(negedge clk);
            write_en = 1'b0;


            addr = 3'h7;
            read_en = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            @(negedge clk);
            addr = 3'h1; data_in = 4'hC; write_en = 1'b1;
            @(negedge clk);

            addr = 3'h2; data_in = 4'hD; write_en = 1'b1;
            @(negedge clk);
            write_en = 1'b0;


            addr = 3'h1;
            read_en = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            @(negedge clk);
            addr = 3'h4; data_in = 4'hB; write_en = 1'b1;
            @(negedge clk);

            addr = 3'h4; data_in = 4'hF; write_en = 1'b0;
            @(negedge clk);


            addr = 3'h4;
            read_en = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            @(negedge clk);
            addr = 3'h5; data_in = 4'h1; write_en = 1'b1;
            @(negedge clk);

            addr = 3'h5; data_in = 4'hE; write_en = 1'b1;
            @(negedge clk);
            write_en = 1'b0;


            addr = 3'h5;
            read_en = 1'b1;
            @(posedge clk);
            #1;
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
        $display("memory Testbench");
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
        $dumpvars(0,addr, clk, data_in, read_en, write_en, data_out);
    end

endmodule
