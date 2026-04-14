`timescale 1ns/1ps

module dual_port_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_address;
    reg we;
    reg [3:0] write_address;
    reg [7:0] write_data;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_memory dut (
        .clk(clk),
        .read_address(read_address),
        .we(we),
        .write_address(write_address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            write_address = 0;
            read_address = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic Write and Read", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            write_address = 4'hA;
            write_data = 8'h55;

            @(negedge clk);
            we = 0;
            read_address = 4'hA;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Write Enable Validation", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            write_address = 4'h5;
            write_data = 8'hAA;


            @(negedge clk);
            we = 0;
            write_address = 4'h5;
            write_data = 8'hFF;

            @(negedge clk);
            read_address = 4'h5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            write_address = 4'h2;
            write_data = 8'h22;


            @(negedge clk);
            we = 1;
            write_address = 4'h3;
            write_data = 8'h33;
            read_address = 4'h2;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Upper Boundary Address 15", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            write_address = 4'hF;
            write_data = 8'hBE;

            @(negedge clk);
            we = 0;
            read_address = 4'hF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Overwriting Existing Data", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            write_address = 4'h7;
            write_data = 8'h11;

            @(negedge clk);
            write_data = 8'h99;

            @(negedge clk);
            we = 0;
            read_address = 4'h7;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h99);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_memory Testbench");
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_address, we, write_address, write_data, read_data);
    end

endmodule
