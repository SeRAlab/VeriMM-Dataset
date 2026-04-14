`timescale 1ns/1ps

module memory_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory dut (
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
            we = 0;
            addr = 0;
            data_in = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write/Read Address 0");
            reset_dut();


            we = 1; addr = 3'd0; data_in = 16'hABCD;
            @(posedge clk);


            we = 0; addr = 3'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write/Read Address 7");
            reset_dut();


            we = 1; addr = 3'd7; data_in = 16'hFFFF;
            @(posedge clk);


            we = 0; addr = 3'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify WE logic (Write when WE is low)");
            reset_dut();


            we = 1; addr = 3'd2; data_in = 16'h1111;
            @(posedge clk);


            we = 0; addr = 3'd2; data_in = 16'hEEEE;
            @(posedge clk);


            we = 0; addr = 3'd2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data persistence across multiple writes");
            reset_dut();


            we = 1; addr = 3'd4; data_in = 16'h4444;
            @(posedge clk);

            we = 1; addr = 3'd5; data_in = 16'h5555;
            @(posedge clk);


            we = 0; addr = 3'd4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite existing data");
            reset_dut();


            we = 1; addr = 3'd1; data_in = 16'hAAAA;
            @(posedge clk);


            we = 1; addr = 3'd1; data_in = 16'h5555;
            @(posedge clk);


            we = 0; addr = 3'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
