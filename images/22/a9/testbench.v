`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] virtual_page;
    reg [3:0] write_data;
    reg write_enable;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .virtual_page(virtual_page),
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
            virtual_page = 2'b00;
            write_data = 4'h0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 0xA to Page 0", test_num);


            virtual_page = 2'd0;
            write_data = 4'hA;
            write_enable = 1;

            @(posedge clk);
            #1;
            write_enable = 0;




            #1;





            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 0x5 to Page 1", test_num);

            virtual_page = 2'd1;
            write_data = 4'h5;
            write_enable = 1;

            @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 0xF to Page 2", test_num);

            virtual_page = 2'd2;
            write_data = 4'hF;
            write_enable = 1;

            @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Writing 0x3 to Page 3", test_num);

            virtual_page = 2'd3;
            write_data = 4'h3;
            write_enable = 1;

            @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting Page 0 (0xA -> 0xC)", test_num);


            virtual_page = 2'd0;
            write_data = 4'hA;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_data = 4'hC;
            @(posedge clk);
            #1;
            write_enable = 0;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Persistence check - Write Page 1, Switch to 2, Switch back to 1", test_num);


            virtual_page = 2'd1;
            write_data = 4'h7;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            virtual_page = 2'd2;
            @(posedge clk);
            #1;


            virtual_page = 2'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input [3:0] expected_read_data;
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
        $dumpvars(0,clk, virtual_page, write_data, write_enable, read_data);
    end

endmodule
