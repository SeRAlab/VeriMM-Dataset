`timescale 1ns/1ps

module NVMe_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg read;
    reg reset;
    reg write;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMe_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .read(read),
        .reset(reset),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            read = 0;
            write = 0;
            data_in = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 32'hDEADBEEF;
            @(posedge clk);
            write = 0;


            read = 1;
            @(posedge clk);

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Write attempt without Enable", test_num);
            reset_dut();


            enable = 0;
            write = 1;
            data_in = 32'hCAFEBABE;
            @(posedge clk);


            enable = 1;
            read = 1;
            @(posedge clk);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Read attempt without Enable", test_num);
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 32'h12345678;
            @(posedge clk);
            write = 0;


            enable = 0;
            read = 1;
            @(posedge clk);



            #1;




            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Consecutive writes", test_num);
            reset_dut();

            enable = 1;
            write = 1;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);
            data_in = 32'hBBBB_BBBB;
            @(posedge clk);
            write = 0;

            read = 1;
            @(posedge clk);

            #1;


            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Data persistence when Read/Write are low", test_num);
            reset_dut();


            enable = 1;
            write = 1;
            data_in = 32'h5555_AAAA;
            @(posedge clk);
            write = 0;


            @(posedge clk);


            read = 1;
            @(posedge clk);

            #1;


            check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Reset behavior after write", test_num);
            reset_dut();

            enable = 1;
            write = 1;
            data_in = 32'hFFFF_FFFF;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            read = 1;
            @(posedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Read signal toggle", test_num);
            reset_dut();

            enable = 1;
            write = 1;
            data_in = 32'h87654321;
            @(posedge clk);
            write = 0;


            read = 0;
            @(posedge clk);


            read = 1;
            @(posedge clk);

            #1;


            check_outputs(32'h87654321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMe_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, read, reset, write, data_out);
    end

endmodule
