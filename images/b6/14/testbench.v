`timescale 1ns/1ps

module ram_256x8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg read_enable;
    reg [7:0] write_data;
    reg write_enable;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_256x8 dut (
        .addr(addr),
        .clk(clk),
        .read_enable(read_enable),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_enable = 0;
            write_enable = 0;
            write_data = 0;
            addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            addr = 8'h10;
            write_data = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;
            read_enable = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Write/Read (0xFF)", test_num);
            reset_dut();


            addr = 8'hFF;
            write_data = 8'h5A;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;
            read_enable = 0;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Data", test_num);
            reset_dut();


            addr = 8'h20;
            write_data = 8'h11;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_data = 8'h22;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;
            read_enable = 0;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Addresses", test_num);
            reset_dut();


            addr = 8'h01; write_data = 8'hB1; write_enable = 1;
            @(posedge clk); #1;

            addr = 8'h02; write_data = 8'hB2;
            @(posedge clk); #1;
            write_enable = 0;


            addr = 8'h01; read_enable = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hB1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Control", test_num);
            reset_dut();


            addr = 8'h30; write_data = 8'h77; write_enable = 1;
            @(posedge clk); #1;


            write_data = 8'h88; write_enable = 0;
            @(posedge clk); #1;


            read_enable = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Control", test_num);
            reset_dut();


            addr = 8'h40; write_data = 8'h99; write_enable = 1;
            @(posedge clk); #1;
            write_enable = 0;




            addr = 8'h00; read_enable = 1;
            @(posedge clk); #1;

            addr = 8'h40; read_enable = 0;
            @(posedge clk); #1;


            read_enable = 1;
            @(posedge clk); #1;

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
        $display("ram_256x8 Testbench");
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
        $dumpvars(0,addr, clk, read_enable, write_data, write_enable, read_data);
    end

endmodule
