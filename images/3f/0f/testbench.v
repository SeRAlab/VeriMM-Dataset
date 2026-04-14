`timescale 1ns/1ps

module virtual_memory_translation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] virtual_address;
    wire [5:0] offset;
    wire [9:0] physical_page_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_translation dut (
        .virtual_address(virtual_address),
        .offset(offset),
        .physical_page_number(physical_page_number)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'h0000 (Min value)", test_num);
            virtual_address = 16'h0000;

            #1;


            check_outputs(6'h00, 10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'hFFFF (Max value)", test_num);
            virtual_address = 16'hFFFF;

            #1;


            check_outputs(6'h3F, 10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'h003F (End of first page)", test_num);
            virtual_address = 16'h003F;

            #1;


            check_outputs(6'h3F, 10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'h0040 (Start of second page)", test_num);
            virtual_address = 16'h0040;

            #1;


            check_outputs(6'h00, 10'h001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'h1234", test_num);
            virtual_address = 16'h1234;



            #1;




            check_outputs(6'h34, 10'h048);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'hABCD", test_num);
            virtual_address = 16'hABCD;



            #1;




            check_outputs(6'h0D, 10'h2AF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Virtual Address = 16'h55AA", test_num);
            virtual_address = 16'h55AA;



            #1;




            check_outputs(6'h2A, 10'h156);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_translation Testbench");
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
        input [5:0] expected_offset;
        input [9:0] expected_physical_page_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_offset === (expected_offset ^ offset ^ expected_offset) &&
                expected_physical_page_number === (expected_physical_page_number ^ physical_page_number ^ expected_physical_page_number)) begin
                $display("PASS");
                $display("  Outputs: offset=%h, physical_page_number=%h",
                         offset, physical_page_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: offset=%h, physical_page_number=%h",
                         expected_offset, expected_physical_page_number);
                $display("  Got:      offset=%h, physical_page_number=%h",
                         offset, physical_page_number);
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

endmodule
