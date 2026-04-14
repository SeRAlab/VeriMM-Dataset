`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg erase;
    reg prog;
    reg read;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .data_in(data_in),
        .erase(erase),
        .prog(prog),
        .read(read),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            erase = 0;
            prog = 0;
            read = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Program 0xAA and Read", test_num);
            reset_dut();


            data_in = 8'hAA;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Erase then Read", test_num);
            reset_dut();


            data_in = 8'h55;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            erase = 1;
            @(posedge clk);
            #1;
            erase = 0;


            read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwrite 0x12 with 0x34", test_num);
            reset_dut();


            data_in = 8'h12;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            data_in = 8'h34;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read Inactive (Expected Output 0)", test_num);
            reset_dut();


            data_in = 8'hFF;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            read = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Erase Priority Check", test_num);
            reset_dut();


            data_in = 8'hCC;
            prog = 1;
            erase = 1;
            @(posedge clk);
            #1;
            prog = 0;
            erase = 0;


            read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Persistence without Control Signals", test_num);
            reset_dut();


            data_in = 8'h77;
            prog = 1;
            @(posedge clk);
            #1;
            prog = 0;


            repeat(3) @(posedge clk);
            #1;


            read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        $dumpvars(0,clk, data_in, erase, prog, read, data_out);
    end

endmodule
